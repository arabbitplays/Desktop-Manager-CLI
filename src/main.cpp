#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h>
#include <unistd.h>
#include <iostream>
#include <string>

int main(int argc, char** argv) {
    if (argc < 2) {
        std::cerr << "Usage: mydaemon-cli <command>\n";
        return 1;
    }

    std::string command = "";
    for (u_int32_t i = 1; i < argc; i++) {
        std::string arg = argv[i];
        command += arg + " ";
    }

    // create socket
    int sock = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("socket");
        return 1;
    }

    struct sockaddr_un addr;
    addr.sun_family = AF_UNIX;
    strcpy(addr.sun_path, "/tmp/desktop_manager.sock"); // match daemon

    if (connect(sock, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        perror("connect");
        return 1;
    }

    // send command
    write(sock, command.c_str(), command.size());
    write(sock, "\n", 1);

    close(sock);
    return 0;
}
