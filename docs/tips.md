

VS Code Tips 
==========================

## Using an SSH tunnel to connect to a remote Docker host 
[Ref Source]( https://code.visualstudio.com/docs/remote/troubleshooting#_container-tips "container tips" )

The Developing inside a container on a remote Docker Machine or SSH host article covers how to setup VS Code when working with a remote Docker host. This is often as simple as setting the docker.host property in settings.json or the DOCKER_HOST environment variable to a ssh:// or tcp:// URI.

However, you may run into situations where this does not work in your environment due to SSH configuration complexity or other limitations. In this case, an SSH tunnel can be used as a fallback.

Using an SSH tunnel as a fallback option

You can set up an SSH tunnel and forward the Docker socket from your remote host to your local machine.

Follow these steps:
    
- Install an OpenSSH compatible SSH client.
- Update the docker.host property in your user or workspace settings.json as follows:

        "docker.host":"tcp://localhost:23750"

- Run the following command from a local terminal / PowerShell (replacing user@hostname with the remote user and hostname / IP for your server):

        ssh -NL localhost:23750:/var/run/docker.sock user@hostname

VS Code will now be able to attach to any running container on the remote host. You can also use specialized, local ___devcontainer.json___ files to create / connect to a remote dev container.

Once you are done, press ___Ctrl+C___ in the terminal / PowerShell to close the tunnel.

Note: If the ssh command fails, you may need to ___AllowStreamLocalForwarding___ on your SSH host.

Open /etc/ssh/sshd_config in an editor (like Vim, nano, or Pico) on the SSH host (not locally).

Add the setting ___AllowStreamLocalForwarding___ yes.
Restart the SSH server (on Ubuntu, run sudo systemctl restart sshd).
Retry.


Docker Tips
========================

## Download image through ssh

        ssh salmon@office ' docker save fylab:latest | bzip2 ' | pv  |bunzip2 | docker load

## Upload image through ssh

        docker save <image id> |bzip2 | pv | ssh salmon@office ' bunzip2 | docker load '