$body = @{"username" = "alfonz" } | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:3000/users -Method POST -ContentType application/json -Body $body