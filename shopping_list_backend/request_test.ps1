$body = @{"name" = "csoki"; "quantity" = 7; "category" = "Shopping" } | ConvertTo-Json

Invoke-WebRequest -Uri http://localhost:3000/add_item -Method POST -ContentType application/json -Body $body