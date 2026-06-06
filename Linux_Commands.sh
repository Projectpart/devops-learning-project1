# Create a test file
touch test.sh
ls -l test.sh          # see current permissions

# Make it executable
chmod +x test.sh
ls -l test.sh          # see the x appear

# Set exact permissions with numbers
chmod 755 test.sh      # owner=rwx, group=rx, others=rx
chmod 644 test.sh      # owner=rw, group=r, others=r
chmod 600 secret.txt   # owner=rw only, no one else

# Change ownership
sudo chown root test.sh        # change owner to root
sudo chown root:root test.sh   # change owner and group
sudo chown $USER test.sh       # give it back to yourself

Process Management
See what's running:
ps aux                        # all running processes
ps aux | grep nginx           # find a specific process
ps aux | grep python          # find python processes

top                           # live process monitor (press q to quit)
htop                          # better version of top (install if needed)

Kill processes:

kill 1234              # graceful stop (SIGTERM) — asks process to stop
kill -9 1234           # force kill (SIGKILL) — no questions asked
pkill nginx            # kill by name
pkill -f "python app"  # kill by full command string

systemctl — managing services:

# Check status of a service
sudo systemctl status nginx
sudo systemctl status ssh

# Start / stop / restart
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx

# Enable on boot / disable
sudo systemctl enable nginx    # starts automatically on reboot
sudo systemctl disable nginx

# View logs for a service
journalctl -u nginx            # all logs
journalctl -u nginx -f         # follow live logs (like tail -f)
journalctl -u nginx --since "1 hour ago"

#Practice — if nginx isn't installed:

sudo apt install nginx -y      # Ubuntu/Debian
sudo systemctl start nginx
sudo systemctl status nginx    # should show active (running)
sudo systemctl stop nginx
sudo systemctl status nginx    # should show inactive

# Test connectivity
ping google.com                # is the host reachable?
ping -c 4 google.com           # send exactly 4 packets

# DNS lookup
nslookup google.com            # what IP does this domain resolve to?
dig google.com                 # more detailed DNS info
host google.com                # simple DNS lookup

# HTTP requests
curl http://localhost           # make a GET request
curl -I http://google.com      # get headers only
curl -X POST http://localhost/api -d '{"key":"value"}' -H "Content-Type: application/json"

# See what ports are open / listening
netstat -tulpn                 # all listening ports
ss -tulpn                      # modern replacement for netstat
sudo ss -tulpn | grep :80      # who is listening on port 80?

# Check your IP
ip addr show                   # all network interfaces and IPs
hostname -I                    # quick IP list

curl -I https://github.com     # see the HTTP headers GitHub sends back
nslookup github.com            # see the IP behind github.com
ss -tulpn                      # see all ports your machine is listening on
ping -c 3 8.8.8.8              # ping Google's DNS server