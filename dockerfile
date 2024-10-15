FROM coqorg/coq
RUN sudo apt update; \
  sudo apt -y install spin; \
  sudo apt -y install vim 
RUN mkdir -p ~/.vim/pack/coq/start \
  git clone https://github.com/whonore/Coqtail.git ~/.vim/pack/coq/start/Coqtail \
  vim +helptags\ ~/.vim/pack/coq/start/Coqtail/doc +q
ADD spin /workspace/spin
ADD coq /workspace/coq
ADD verifyMyCHIPs.sh /workspace/verifyMyCHIPs.sh
WORKDIR /workspace 

