import tarfile, zstandard, os, sys, shutil

src = os.environ.get("BOOTSTRAP_TAR")
dst = os.environ.get("EXTRACT_DIR")

if not src or not dst:
    print("Usage: set BOOTSTRAP_TAR and EXTRACT_DIR env vars")
    sys.exit(1)

os.makedirs(dst, exist_ok=True)
print(f"Extracting {src} to {dst} ...")

dctx = zstandard.ZstdDecompressor()
with open(src, 'rb') as f:
    with dctx.stream_reader(f) as reader:
        with tarfile.open(fileobj=reader, mode='r|') as tar:
            for i, member in enumerate(tar):
                tar.extract(member, path=dst)
                if i % 100 == 0:
                    print(f"  Extracted {i} files...", end='\r')

print(f"\nDone. Extracted to {dst}")
