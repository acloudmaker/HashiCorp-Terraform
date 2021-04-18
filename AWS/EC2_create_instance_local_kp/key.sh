# Run this before terraform init and other steps
$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/home/USERID/.ssh/id_rsa): mykp
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in mykp
Your public key has been saved in mykp.pub
The key fingerprint is:
SHA256:dKea/+qHVe7QuU2aQ75TJGtg8Zy/QCgOcG46XG9j80U jdl@CPX-FH9704IWWUE
The key's randomart image is:
+---[RSA 3072]----+
|                 |
|     . .    .    |
|      + . . o+ . |
|       * o +oE* .|
|    . + S o.o= * |
|     +   X  ooB +|
|      . = +o.*.B.|
|         .... O..|
|         .++. .+ |
+----[SHA256]-----+

$ chmod 400 mykp*

$ terraform fmt main.tf
$ terraform init
$ terraform plan -out="myplan.out"
$ terraform apply "myplan.out"
$ terraform output
public_dns = "ec2-100-26-11-149.compute-1.amazonaws.com"
public_ip = "100.26.11.149"

# The following should work if everything is successful
$ ssh -i mykp ec2-user@ec2-100-26-11-149.compute-1.amazonaws.com
$ ssh -i mykp ec2-user@100.26.11.149

$ ping ec2-100-26-11-149.compute-1.amazonaws.com
$ ping 100.26.11.149
