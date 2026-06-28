import tarfile, os, re, sys

src = os.environ["TAR_SRC"]
dst = os.environ["TAR_DST"]

os.makedirs(dst, exist_ok=True)

def safe_name(path):
    parts = path.replace("\\", "/").split("/")
    fixed = []
    for p in parts:
        p = re.sub(r"(:)(?=[\d\.])", "_", p)
        fixed.append(p)
    return "/".join(fixed)

print(f"Extracting tar to {dst}...")
with tarfile.open(src, mode="r") as tar:
    for i, member in enumerate(tar):
        member.name = safe_name(member.name)
        # Skip invalid names
        if ".." in member.name or member.name.startswith("/"):
            continue
        tar.extract(member, path=dst)
        if i % 500 == 0:
            print(f"  {i}...", end="\r")

print(f"\nDone. Extracted {i+1} files to {dst}")
