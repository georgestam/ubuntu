## Users

### Create User end-point
```   
curl -H "Content-Type: application/json" -X POST -d '{ "user": { "email": "testing@email.com", "password": "password10", "name": "jordin" } }' http://localhost:3000/users.json
```   

## Recordings

### Index end-point
```   
curl -s http://localhost:3000/api/respira/v1/recordings | jq
```   

### Show end-point
```   
curl -s http://localhost:3000/api/v1/recordings/1 | jq
```   

### Update end-point
```   
curl -i -X PATCH                                           \
       -H 'Content-Type: application/json'                 \
       -H 'X-User-Email: jordi@voiceable.io'               \
       -H 'X-User-Token: Jr3iddz3DwsMb1UUcgpG'             \
       -d '{ "recording": { "data": "Some new Jason as string", "description": "Whatever new" } }' \
       http://localhost:3000/api/respira/v1/recordings/1 
```   
  
### Create end-point    
```   
curl -i -X POST                                                              \
    -H 'Content-Type: application/json'                                      \
    -H 'X-User-Email: testing@email.com'                                    \
    -H 'X-User-Token: 2B5y-xE_LdwnzqsEZgh9'                                  \
    -d '{ "recording": { "data": "Some Jason as string", "description": "Whatever", "confidence": "80", "speaker": "1" } }' \
    http://localhost:3000/api/respira/v1/recordings
```