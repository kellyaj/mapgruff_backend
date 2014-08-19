@dir = "/path/to/dir"

worker_processes 2
working_directory @dir

timeout 30

listen "#{@dir}tmp/sockets/unicorn.sock", :backlog => 64

pid "#{@dir}tmp/pids/unicorn.pid"

listen "#{@dir}log/unicorn.stderr.log"
listen "#{@dir}log/unicorn.stdout.log"
