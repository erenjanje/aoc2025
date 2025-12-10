$result = (Get-ChildItem -Path "./result" -File | ForEach-Object {
    $file = $_.Name
    $match = scip -f "./result/$file" | Select-String -Pattern "objective value:\s+(\d+)"
    [PSCustomObject]@{
        File = $file
        Sum  = [int]$match.Matches[0].Groups[1].Value
    }
})
