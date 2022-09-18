import os
import shutil
import subprocess
import sys


def copy_dotfiles():
    filenames = [
        ".bashrc",
        ".git-completion.bash",
        ".gitconfig",
        ".tmux.conf",
    ]

    for filename in filenames:
        source_path = os.path.join(os.getcwd(), filename)
        try:
            target_path = os.environ["HOME"]
        except:
            print("$HOME env var not set.")
            raise SystemExit()

        subprocess.call(["cp", source_path, target_path])

        # if os.path.isfile(source_path):
        #     print('File exists: {}'.format(filename))
        # else:
        #     subprocess.call(['cp', source_path, target_path])

        # subprocess.call(['ln', '-s', source_path, target_path])


def copy_bin():
    source_path = "./bin"
    target_path = "/home/tom/bin"

    shutil.copytree(source_path, target_path, dirs_exist_ok=True)
    os.chdir(target_path)
    filenames = os.listdir(".")
    for filename in filenames:
        os.chmod(filename, 0o755)


if __name__ == "__main__":
    copy_dotfiles()
    # copy_bin()
