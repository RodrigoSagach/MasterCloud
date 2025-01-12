{foreach from=$categories item=i name=cat}
    <li class="{if $i.visible=='0'}hidden{/if} {if $i.visible==-1}archived{/if} entry" id="entry{$i.id}" >
        <div >
            <table width="100%" cellspacing="0" cellpadding="3" border="0" class="glike">
                <tr  class="havecontrols">
                    <td width="20">
                        <input type="hidden" name="sort[]" value="{$i.id}" /><div class="controls"><a class="sorter-handle" >{$lang.move}</a></div>
                    </td>
                    <td width="20%" class="name">
                        <a href="?cmd=services&action=category&id={$i.id}" class="direct">
                            {if $i.visible==1}{$i.name}
                            {else}<em class="hidden">{$i.name} </em>
                            {/if}
                        </a> 
                        {if $i.visible=='0'}
                            <em class="hidden fs11">{$lang.hidden}</em>
                        {elseif $i.visible==-1}
                            <em class="hidden fs11">Archived</em>
                        {/if}
                    </td>
                    <td width="120"><a href="?cmd=services&action=category&id={$i.id}" class="direct">{$i.products}</a></td>
                    <td >
                        {if $lang[$i.otype]} {$lang[$i.otype]}
                        {elseif $i.template=='custom'}{$lang.typespecificcheckout}
                        {else}{$i.otype|replace:'_':' '|capitalize}
                        {/if}
                    </td>
                    <td style="width: 120px; text-align: right">
                        {if $i.visible=='0'}
                            <a href="?cmd=services&action=toggle&state=visible&id={$i.id}&security_token={$security_token}" 
                               class="menuitm menu-auto ajax" style="min-width: 30px; text-align: center">{$lang.Show}</a>
                        {elseif $i.visible=='-1'}
                            <a href="?cmd=services&action=toggle&state=visible&id={$i.id}&security_token={$security_token}" 
                               class="menuitm menu-auto ajax" style="min-width: 30px; text-align: center">Restore</a>
                        {else}
                            <a href="?cmd=services&action=toggle&state=archive&id={$i.id}&security_token={$security_token}" 
                               class="menuitm menu-auto ajax" >Archive</a>

                            <a href="?cmd=services&action=toggle&state=hide&id={$i.id}&security_token={$security_token}" 
                               class="menuitm menu-auto ajax" >{$lang.Hide}</a>
                        {/if}
                    </td>
                    <td style="width: 80px; text-align: right">
                        <a href="?cmd=services&action=editcategory&id={$i.id}" class="menuitm menu-auto"><span style="color: red">{$lang.Edit}</span></a>
                        <a href="?cmd=services&make=deletecat&id={$i.id}&security_token={$security_token}" 
                           onclick="return confirm('{$lang.deletecategoryconfirm}');" class="menuitm menu-auto ajax"><span class="delsth"></span></a> 
                    </td>
                </tr>
            </table>
        </div>
    </li>
{/foreach}