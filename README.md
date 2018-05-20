# Supercomputers
A Repository to store our work for the Supercomputers course at TUM.

Authors: John Kourdis, Patrick O'Connor and William Parker

## Accessing SuperMUC:

First users will need to ssh into the TUM rechnerhalle using the command

~:ssh <username>@halle.in.tum.de

To run programs on the superMUC you will then need to ssh into your provided superMUC account

~:ssh <username2>@supermuc.lrz.de

### SuperMUC Architectures

To access the Phase one architecture use the following command:

~:ssh username@sb.supermuc.lrz.de

To access the Phase two architecture use the following command:

~:ssh username@hw.supermuc.lrz.de

### Running a batch on the SuperMUC

Once you have logged in to your chosen architecture you need to run a batch in order to get stable results.  In order to submit a batch to run a program
use the following command:

~:llsubmit ll.sh

To query the status of a job you can use the following

~:llq -u username

To cancel a job run the following

~:llcancel jobid

## Recommended workflow:

It is recommended that users clone the git repository found here: https://wparker89@bitbucket.org/wparker89/supercomputers.git using the command

~:git clone https://wparker89@bitbucket.org/wparker89/supercomputers.git

in their halle.in.tum.de workspace.  All development should be carried out here and run locally, any changes should be pushed using a normal git workflow.

## Transferring files to and from SuperMUC

Up until now I have not been able to clone a git repo onto the SuperMUC but it *is* possible (apparently).  Until we figure that out recommended to
transfer files with rsync. Used as follows:

~:rsync -a ~/dir_to_copy username@remote_host:destination_directory

This will use ssh to copy the specifed directory and all subdirectories to the destination_directory.  For more information see: https://www.digitalocean.com/community/tutorials/how-to-use-rsync-to-sync-local-and-remote-directories-on-a-vps

rsync *cannot* be used on the SuperMUC itself.  In order to copy your results from SuperMUC to your local workspace you need to run the following command:

~:rsync -a username@remote_host:dir_to_fetch local_directory_to_copy_to

## Report

The report will be written in Latex using the platfrom sharelatex, so that we can all easily collaborate on producing it.  The report can be accessed here:
https://www.sharelatex.com/project/5a01a12bf091a63ae216d57d
