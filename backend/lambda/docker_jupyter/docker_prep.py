import hashlib
import os
import shutil
from pathlib import Path

DIRECOTY = str(Path(__file__).resolve().parent)


# docs - https://stackoverflow.com/questions/36204248/creating-unique-hash-for-directory-in-python
def sha1_of_file(filepath: str):
    sha = hashlib.sha1()
    sha.update(filepath.encode())

    with open(filepath, "rb") as f:
        for block in iter(lambda: f.read(2**10), b""):
            sha.update(block)
        return sha.hexdigest()


def hash_dir(dir_path: str):
    sha = hashlib.sha1()

    for path, _, files in os.walk(dir_path):
        # we sort to guarantee that files will always go in the same order
        for file in sorted(files):
            file_hash = sha1_of_file(os.path.join(path, file))
            sha.update(file_hash.encode())

    return sha.hexdigest()


def copy_shared():
    if Path(__file__).resolve().parent.joinpath("shared").exists():
        shutil.rmtree(Path(__file__).resolve().parent.joinpath("shared"))
    shutil.copytree(Path(__file__).resolve().parent.parent.joinpath("shared"), Path(__file__).resolve().parent.joinpath("shared"))


if __name__ == "__main__":
    copy_shared()
    print(f""" {{ "hash": "{hash_dir(DIRECOTY)}" }} """)