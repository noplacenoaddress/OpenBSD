- arp sentinel

- ``` shell
  if [[ $# -eq 0 ]]; then
  	print $0 "have to be used with the following options \
  			\n \
  			\ninstall  -> fresh install OpenBSD VPS \
  			\nupgrade  -> upgrade OpenBSD VPS \
  			\nreset    -> reset OpenBSD VPS \
  			\n"
  	
  	exit 1
  fi
  ```

