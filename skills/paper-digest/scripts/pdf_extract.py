#!/usr/bin/env python3
"""
Get readable content out of a paper PDF, including scans.

Two things commonly go wrong when reading a paper PDF, and they fail in different ways:

  1. The PDF has a text layer -> just extract the text. Fast, cheap, exact.
  2. The PDF is a scan (common for pre-2000 landmark papers) -> there is no text.
     The Read tool can't render pages without poppler installed, so the workaround is
     to pull the embedded page images out and read those visually.

This script figures out which case you're in and does the right thing.

Usage:
    python pdf_extract.py paper.pdf [--outdir DIR]

Output:
    - Text-layer PDFs: writes <outdir>/text.txt and prints it to stdout.
    - Scanned PDFs:    writes <outdir>/page-NN.png files and prints their paths.
                       Read those with the Read tool, in order.

Requires: pypdf, and pillow only for scanned PDFs.
    python -m pip install pypdf pillow
"""
import argparse
import pathlib
import sys

# Below this many characters, a page is almost certainly a scan rather than real text.
# Scanned pages still carry a few chars of publisher boilerplate (e.g. a copyright line),
# so testing for "zero text" would miss them.
TEXT_THRESHOLD = 200


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("pdf")
    ap.add_argument("--outdir", default=None)
    ap.add_argument("--threshold", type=int, default=TEXT_THRESHOLD)
    ap.add_argument("--print", dest="print_text", action="store_true",
                    help="Dump extracted text to stdout instead of just naming the file.")
    args = ap.parse_args()

    pdf = pathlib.Path(args.pdf)
    if not pdf.exists():
        sys.exit(f"No such file: {pdf}")

    # Validate the file before parsing. A truncated or HTML-error download otherwise
    # surfaces as an obscure pypdf traceback ("Cannot find Root object in pdf"), which
    # reads like a scanned-PDF problem and sends you down a long, wrong path.
    head = pdf.open("rb").read(5)
    tail = pdf.open("rb").read()[-1024:] if pdf.stat().st_size < 200_000_000 else b"%%EOF"
    if head != b"%PDF-":
        sys.exit(f"{pdf.name} is not a PDF (starts with {head!r}). "
                 "The download probably returned an HTML error page — re-download it.")
    if b"%%EOF" not in tail:
        sys.exit(f"{pdf.name} looks truncated (no %%EOF marker, {pdf.stat().st_size} bytes). "
                 "Re-download it; this is a broken transfer, not a scanned document.")
    outdir = pathlib.Path(args.outdir or pdf.parent / f"{pdf.stem}_extracted")
    outdir.mkdir(parents=True, exist_ok=True)

    try:
        from pypdf import PdfReader
    except ImportError:
        sys.exit("Missing pypdf. Run: python -m pip install pypdf")

    reader = PdfReader(str(pdf))
    pages = reader.pages
    texts = []
    for p in pages:
        try:
            texts.append((p.extract_text() or "").strip())
        except Exception:
            texts.append("")

    good = sum(1 for t in texts if len(t) >= args.threshold)
    print(f"[pdf_extract] {len(pages)} pages; {good} have a usable text layer.", file=sys.stderr)

    if good >= max(1, len(pages) // 2):
        # Namespace by the PDF's own name. A fixed "text.txt" collides silently when
        # several papers are extracted into one directory -- and a digest built from
        # another paper's text is the worst failure this skill can produce.
        out = outdir / f"{pdf.stem}.txt"
        joined = "\n\n".join(f"===== PAGE {i+1} =====\n{t}" for i, t in enumerate(texts))
        out.write_text(joined, encoding="utf-8")
        print(f"[pdf_extract] MODE=text ({len(joined.split())} words)", file=sys.stderr)
        # Deliberately NOT dumping the text to stdout: a full paper is 7-10k words and
        # printing it burns context for no gain. Read the file instead, or pass --print.
        if args.print_text:
            sys.stdout.write(joined)
        else:
            print(out)
        return

    # Scanned path: pull embedded images and normalise them to PNG.
    print("[pdf_extract] MODE=scan (no usable text layer)", file=sys.stderr)
    try:
        from PIL import Image
    except ImportError:
        sys.exit("Scanned PDF needs pillow. Run: python -m pip install pillow")

    written = []
    for i, page in enumerate(pages):
        try:
            images = list(page.images)
        except Exception as e:
            print(f"[pdf_extract] page {i+1}: cannot enumerate images ({e})", file=sys.stderr)
            continue
        if not images:
            print(f"[pdf_extract] page {i+1}: no embedded images", file=sys.stderr)
            continue
        # Scanned pages usually hold one full-page raster plus, sometimes, small figure
        # insets. The largest image is the page itself; keep the others as extras since
        # a figure inset is occasionally the clearest copy of a diagram.
        images.sort(key=lambda im: len(im.data), reverse=True)
        for k, im in enumerate(images):
            raw = outdir / f"_raw_p{i+1:02d}_{k}"
            raw.write_bytes(im.data)
            suffix = "" if k == 0 else f"-inset{k}"
            dest = outdir / f"{pdf.stem}-page-{i+1:02d}{suffix}.png"
            try:
                with Image.open(raw) as img:
                    # Mode "1" (bilevel fax scans) renders poorly; "L" is much more legible.
                    img.convert("L").save(dest)
                written.append(dest)
            except Exception as e:
                print(f"[pdf_extract] page {i+1} img {k}: convert failed ({e})", file=sys.stderr)
            finally:
                raw.unlink(missing_ok=True)

    if not written:
        sys.exit("[pdf_extract] Could not recover text or images. Ask the user for another copy.")

    print(f"[pdf_extract] Wrote {len(written)} page images. Read these in order:", file=sys.stderr)
    for w in written:
        print(w)


if __name__ == "__main__":
    main()
