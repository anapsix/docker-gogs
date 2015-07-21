## Gogs in a box

[![](https://badge.imagelayers.io/anapsix/gogs:latest.svg)](https://imagelayers.io/?images=anapsix/gogs:latest)

[Gogs](http://gogs.io) - A painless self-hosted Git service (in a Docker container).

This is mostly 1/10th in size adaptation of @codeskyblue's [container image](https://github.com/codeskyblue/docker-gogs) to AlpineLinux-based image.

> Work-in-progress.. sort of works

## Usage

1. Start the container:

      docker run -it --rm -p 3000:3000 -p 3022:22 anapsix/gogs

2. Go to [http://localhost:3000](http://localhost:3000)
3. Proceed through _Installation_ questionnaire.  
   For file/directory locations use absolute paths (e.g. `/data/gogs.db`, `/data/gogs-repositories`).
4. Login with newly created _Admin Account_.

