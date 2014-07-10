# backuppc_pubkey.rb

Facter.add('backuppc_pubkey') do
    setcode do
        keyfile = '.ssh/id_rsa.pub'
        userhome = `egrep '^backuppc:' /etc/passwd | cut -d: -f6`.chomp()
        if File.exist?("#{userhome}/#{keyfile}")
            File.read("#{userhome}/#{keyfile}").split(' ')[1]
        else
            ''
        end
    end
end
