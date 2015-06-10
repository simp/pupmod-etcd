Summary: Etcd Puppet Module
Name: pupmod-simp-etcd
Version: 0.1.0
Release: 0
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: puppetlabs-stdlib
Requires: pupmod-iptables
Requires: puppet >= 3.4
Buildarch: noarch

Prefix: /etc/puppet/environments/simp/modules

%description
A pupmod to install and configure ETCD.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/etcd

dirs='lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/etcd
done

cp README.md %{buildroot}/prefix/etcd

# Make Puppet stop complaining about not having facts.d
mkdir -p %{buildroot}%{prefix}/etcd/facts.d

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/etcd

%files
%defattr(0640,root,puppet,0750)
%{prefix}/etcd

%post
#!/bin/sh

if [ -d %{prefix}/etcd/plugins ]; then
  /bin/mv %{prefix}/etcd/plugins %{prefix}/etdc/plugins.bak
fi

%postun
# Post uninstall stuff

%changelog
* Wed Jun 10 2015 - Nick Markowski <nmarkowski@keywcorp.com> - 0.1.0-0
- Module based off of Kyle Anderson's etcd:
  https://github.com/solarkennedy/puppet-etcd
- Added exported resources for iptables rules.
- Added /etc/sysconfig/etcd template.
- Added SSL support.  By default etcd uses Puppet certs.
- Added getter/setter functions for key/value pairs.
