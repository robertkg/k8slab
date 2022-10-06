$uri = 'http://localhost:5291/tasks'
@(
    '{"Name":"Build it","Description":"Make some stuff","IsComplete":true}',
    '{"Name":"Break it","Description":"Make sure it breaks","IsComplete":true}',
    '{"Name":"Fix it","Description":"","IsComplete":false}',
    '{"Name":"Fix it again","Description":"","IsComplete":false}'
) | ForEach-Object {
    Invoke-RestMethod -Uri $uri -Method Post -ContentType 'application/json' -Body $_ 1>$null
}

Invoke-RestMethod -Uri $uri -Method Get