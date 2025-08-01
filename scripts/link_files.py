import os
import subprocess
import shutil


def link_dotfiles():
    filenames = [
        ".bashrc",
        ".git-completion.bash",
        ".gitconfig",
        ".tmux.conf",
        ".command_palette"
    ]

    for filename in filenames:
        source_path = os.path.join(os.getcwd(), "../", "dotfiles", filename)
        try:
            target_path = os.environ["HOME"]
        except:
            print("$HOME env var not set.")
            raise SystemExit()

        try:
            subprocess.call(['ln', '-s', source_path, target_path])
        except:
            print("Link probably exists", filename)


def copy_bin():
    source_path = "./bin"
    target_path = "/home/tom/bin"

    shutil.copytree(source_path, target_path, dirs_exist_ok=True)
    os.chdir(target_path)
    filenames = os.listdir(".")
    for filename in filenames:
        os.chmod(filename, 0o755)


if __name__ == "__main__":
    link_dotfiles()
