{foreach from=$c.items item=cit}<input name="custom[{$kk}][{$cit.id}]"  value="{$c.data[$cit.id]|dateformat:$date_format}" class="haspicker"/> {$cit.name}  {/foreach}