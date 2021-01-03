$list = "c:\tmp2" , "c:\ArchiveDB" , "c:\Live2"

foreach ($ii in $list) {
	$item = Get-ChildItem -Path $ii -File archives_cache.xml -Recurse -Depth 5
	write-host "Found in $ii - $($item.Directory.Name) $($item.Name) "
}