### InvoiceApp.dev  

This is an App developed from scartch for the purpose of an Assessment.

The Vagrant box is Based on the latest LTS of Ubuntu(16.04 at the moment).

On provisioning it will install a classic LAMP stack with Apache2, PHP-7.0, composer and MySQL


### How to use

- [] If you want to, add the domain to /etc/hosts file like so:
```
192.168.33.10 invoice-app.dev
```

- [] Run `vagrant up`
- [] Go get a coffee or just wait a bit...
- [] When the last step is finnished, visit the domain you configured on a web browser

In case you didnt add the Domain please use the ip address 192.168.33.10.

If you get redirected to https and get a blank page please notice that I didnt configure this VM to support https. Chrome now enforces it so give a try to Firefox.

Thanks.


