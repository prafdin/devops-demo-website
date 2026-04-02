#include <iostream>
#include <string>
#include <ctime>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <curl/curl.h>
#include <cstring>

const int PORT = 5000;
const char* DELAY_URL = "https://httpbin.org/delay/0.1";

void perform_request() {
    CURL* curl = curl_easy_init();
    if (curl) {
        curl_easy_setopt(curl, CURLOPT_URL, DELAY_URL);
        curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);
        curl_easy_setopt(curl, CURLOPT_TIMEOUT, 5L);
        CURLcode res = curl_easy_perform(curl);
        if(res != CURLE_OK) {
            std::cerr << "Request failed: " << curl_easy_strerror(res) << "\n";
        }
        curl_easy_cleanup(curl);
    }
}

std::string create_response() {
    char host[256];
    gethostname(host, sizeof(host));

    std::time_t t = std::time(nullptr);
    char timestamp[64];
    std::strftime(timestamp, sizeof(timestamp), "%Y-%m-%dT%H:%M:%S", std::localtime(&t));

    return std::string("{\"hostname\":\"") + host +
           "\",\"timestamp\":\"" + timestamp +
           "\",\"message\":\"Backend service is running!\"}";
}

int main() {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == 0) { perror("socket"); return 1; }

    sockaddr_in address{};
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0) {
        perror("bind"); return 1;
    }
    if (listen(server_fd, 10) < 0) {
        perror("listen"); return 1;
    }

    std::cout << "Server listening on port " << PORT << "\n";

    while (true) {
        int addrlen = sizeof(address);
        int client = accept(server_fd, (struct sockaddr*)&address, (socklen_t*)&addrlen);
        if (client < 0) { perror("accept"); continue; }

        char buffer[1024] = {0};
        read(client, buffer, 1024);

        if (strncmp(buffer, "GET /info", 9) == 0) {
            perform_request(); // блокирующий внешний запрос
            std::string response_body = create_response();
            std::string http_response =
                "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: " +
                std::to_string(response_body.size()) + "\r\n\r\n" + response_body;

            write(client, http_response.c_str(), http_response.size());
        }

        close(client);
    }

    close(server_fd);
    return 0;
}