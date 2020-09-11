import os
import subprocess

filenames = [
    '.bashrc',
    '.git-completion.bash',
    '.gitconfig',
#    '.tmux.conf',
]

for filename in filenames:
    source_path = os.path.join(os.getcwd(), filename)
    try:
        target_path = os.environ['HOME']
    except:
        print('$HOME env var not set.')
        raise SystemExit()

    subprocess.call(['cp', source_path, target_path])
    
    # if os.path.isfile(source_path):
    #     print('File exists: {}'.format(filename))
    # else:
    #     subprocess.call(['cp', source_path, target_path])

        # subprocess.call(['ln', '-s', source_path, target_path])
