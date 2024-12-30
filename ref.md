# top
Purpose: Real-time system monitoring
Key features:
- Updates every 3 seconds by default
- Shows CPU, memory, swap usage
- Lists processes sorted by CPU usage
- Interactive navigation using keys

Common options:
-d N : Update every N seconds
-p PID : Monitor specific process
-u username : Show specific user's processes
-b : Batch mode output
-n N : Exit after N iterations

Interactive commands:
k - kill process
r - renice process
f - select fields to display
s - change update frequency

# htop
Purpose: Enhanced version of top with more features
Advantages over top:
- Color-coded output
- Mouse support
- Vertical and horizontal scrolling
- Tree view of processes
- Better UI with function key shortcuts

Key features:
- CPU, memory, swap usage bars
- Process filtering and searching
- Kill process with multiple signals
- Custom column configuration
- Process tree view (F5)

Function keys:
F1 - Help
F3 - Search process
F4 - Filter
F5 - Tree view
F6 - Sort by column
F9 - Kill process

# ps
Purpose: Shows snapshot of current processes
Common usage:
ps aux - Show all processes for all users
ps -ef - Full format listing
ps -u username - Show user's processes
ps -p PID - Show specific process

Options explained:
a - all processes with terminals
u - user-oriented format
x - processes without terminals
f - full format listing
e - show environment variables

# sort
Purpose: Sort text lines in files
Common usage with ps:
ps aux | sort -k 3 (sort by CPU)
ps aux | sort -k 4 (sort by memory)

Key options:
-n : Numeric sort
-r : Reverse sort
-k N : Sort by column N
-u : Remove duplicates

# head
Purpose: Display first lines of file
Common usage:
head -n 10 (show first 10 lines)
ps aux | sort -k 3 | head -n 5 (top 5 CPU-using processes)

Options:
-n N : Show first N lines
-c N : Show first N bytes

# uptime
Purpose: Show system running time and load averages
Output explained:
- Current time
- System up time
- Number of users
- Load averages (1, 5, 15 minutes)

Example:
14:30:00 up 7 days, 2 users, load average: 0.15, 0.20, 0.18

# mpstat
Purpose: CPU statistics monitoring
Key features:
- Per-processor statistics
- CPU utilization breakdown
- Interrupt activity

Common usage:
mpstat -P ALL 2 (all CPUs, 2-second intervals)

Output columns:
%usr - User level
%sys - System level
%iowait - IO wait
%idle - Idle time

# ulimit
Purpose: Set/show user resource limits
Common limits:
-n : Max open files
-u : Max user processes
-f : Max file size
-m : Max memory size
-v : Max virtual memory

Example:
ulimit -a (show all limits)
ulimit -n 65535 (set max open files)

# pstree
Purpose: Display process tree
Features:
- Shows parent-child relationships
- Compact tree visualization
- Process grouping

Options:
-p : Show PIDs
-a : Show command line arguments
-h : Highlight current process

# systemctl vs journalctl

systemctl:
Purpose: Control the systemd system and service manager
Common commands:
- systemctl start/stop service
- systemctl enable/disable service
- systemctl status service
- systemctl restart service
- systemctl list-units

journalctl:
Purpose: Query systemd's journal logging system
Key features:
- Structured log storage
- Filtering capabilities
- Time-based queries

Differences:
systemctl: Service management and control
journalctl: Log viewing and analysis

Common journalctl usage:
- journalctl -u service-name
- journalctl --since today
- journalctl -p err
- journalctl -f (follow mode)

# perf
Purpose: Performance analysis tool
Key features:
- CPU performance counters
- Hardware events
- Software events
- Tracepoint events

Common commands:
perf top - Real-time system profiling
perf record - Record system performance
perf report - Analysis report

# strace
Purpose: Trace system calls and signals
Use cases:
- Debug applications
- Understand system behavior
- Track file operations
- Monitor process communication

Common options:
-p PID : Attach to process
-e trace=write : Trace specific calls
-c : Count time, calls, errors

# free
Purpose: Display memory usage
Output sections:
- Total memory
- Used memory
- Free memory
- Shared memory
- Buffers/cache

Common options:
-h : Human readable
-s N : Update every N seconds
-t : Show totals

# vmstat
Purpose: Virtual memory statistics
Features:
- Process status
- Memory usage
- Swap usage
- IO stats
- System stats
- CPU activity

Common usage:
vmstat 1 (update every second)
vmstat -s (memory stats)

# top vs htop
top:
- Lighter on resources
- Available by default
- Basic interface
- Limited interaction

htop:
- More user-friendly
- Better visual presentation
- Mouse support
- Advanced features like searching
- Process tree view

# systemctl vs journalctl
systemctl:
- Service management
- System state control
- Boot target management
- Service dependency handling

journalctl:
- Log management
- Log filtering
- Log analysis
- Real-time log monitoring

# atop vs top/htop:
- More detailed system resources
- Historical data logging
- Disk I/O statistics
- Network utilization

# glances vs top/htop:
- Web interface option
- Cross-platform
- More modern UI
- Additional monitoring features

# nmon vs vmstat:
- Comprehensive system monitoring
- Performance data collection
- Multiple view modes
- Data export capabilities
