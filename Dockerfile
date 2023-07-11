FROM marwaney/ssh-server
# install ssh server to access via ssh
RUN apt-get install -y openssh-server
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]

