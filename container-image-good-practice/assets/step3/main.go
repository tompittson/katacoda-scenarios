package main
 
import (
    "fmt"
    "os"
    "os/user"
    "net"
) 
 
func main() {
    var u *user.User
    var grp *user.Group
    u, _ = user.Current()
    grp, _ = user.LookupGroupId(u.Gid)
    fmt.Println("UID:", u.Uid)
    fmt.Println("Username:", u.Username)
    fmt.Println("Home: " + u.HomeDir)
    fmt.Println("GID:", u.Gid)
    fmt.Println("Group name:", grp.Name)
    fmt.Println()

    path, err := os.Getwd()
    if err != nil {
        fmt.Println(err)
    }
    fmt.Println("Working Directory:", path)

    executable, err := os.Executable()
    if err != nil {
        fmt.Println(err)
    }
    fmt.Println("Executable:", executable)
    fmt.Println()
    
    fmt.Println("Environment variables:")
    for _, pair := range os.Environ() {
        fmt.Println(pair)
    }

    fmt.Println()
    host, _ := os.Hostname()
    fmt.Println("Hostname: ", host)
    addrs, _ := net.LookupIP(host)
    for _, addr := range addrs {
        if ipv4 := addr.To4(); ipv4 != nil {
            fmt.Println("IPv4: ", ipv4)
        }   
    }
}