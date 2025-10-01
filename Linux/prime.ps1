function checkprime {
    param (
        [int]$num
    )
    for($i=2;$i -le $num / 2; $i++)
    {
        if ($num % $i -eq 0)
        {
            return $false
        }
    }
    return $true;
}

$n = Read-Host "Enter a number to check for prime"
$n = [int]$n
if (checkprime($n))
{
    "prime"
}
else {
    "not prime"
} 