# Instabug Interview Task
 
`
It is just a netwrking framework, that is all about caching api hits in a synchronized matter 
`

# Configuration
All you need, is just importing the module in your .swift file and you are god to go

```
import InstabugNetworkClient
```
```
NetworkClient(cacheModel:.memory)
```
```
NetworkClient(cacheModel:.physical).get(url: , completion: ){_ in}
```

# Technologies
```
* Framwork
* Unit Testing
* Core data (concurrency)
```
