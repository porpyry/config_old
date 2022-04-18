function ls --wraps='exa -al --group-directories-first' --description 'alias ls=exa -al --group-directories-first'
  exa -al --group-directories-first $argv; 
end
