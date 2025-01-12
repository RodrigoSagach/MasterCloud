<div class="wbox">
    <div class="wbox_header">
        <strong>{$lang.serviceupgrade}: {$contents.product.product_name}</strong>

    </div>
    <div class="wbox_content">
        <table cellspacing="0" cellpadding="0" border="0" align="center" width="100%" class="checker table">
            <tbody>
                <tr>
                    <th width="55%" align="left">{$lang.Description}</th>
                    <th width="25%">{$lang.price}</th>
                </tr>
                {if $contents.product && $contents.product.product_id != $contents.product.new_product_id}
                    <tr class="srow">
                        <td valign="top">
                            {$contents.product.upgrade_name}
                        </td>
                        <td align="center"><strong>{$contents.product.charge|price:$currency}</strong></td>
                    </tr>
                {/if}

                {if $contents.config}
                    {foreach from=$contents.config  item=cstom}
                        {if $cstom.hidden}{continue}{/if}
                        <tr >
                            <td valign="top" class="blighter fs11" style="padding-left:15px">
                                <b>{$cstom.config_cat_name}</b>: 
                                    {if $cstom.new_qty!=$cstom.old_qty}
                                        {$cstom.old_qty} =&gt; {$cstom.new_qty} {if $cstom.new_config_name}x {$cstom.new_config_name}
                                    {/if}
                                {else}
                                    {$cstom.old_config_name} =&gt; {$cstom.new_config_name}
                                {/if}

                                <br/>
                            </td>
                            <td align="center" class="blighter fs11"><strong>{$cstom.charge|price:$currency}</strong></td>
                        </tr>
                    {/foreach}
                {/if}

                {if $tax}
                    <tr >
                        <td align="right" >{$lang.subtotal}</td>
                        <td align="center" >{$tax.subtotal|price:$currency}</td>
                    </tr>

                    {if $tax.tax1 && $tax.taxed1!=0}
                        <tr >
                            <td align="right" >{$tax.tax1name} @ {$tax.tax1}%  </td>
                            <td align="center">{$tax.taxed1|price:$currency}</td>
                        </tr>
                    {/if}

                    {if $tax.tax2  && $tax.taxed2!=0}
                        <tr >
                            <td align="right" >{$tax.tax2name} @ {$tax.tax2}%  </td>
                            <td align="center">{$tax.taxed2|price:$currency}</td>
                        </tr>
                    {/if}

                    {if $tax.credit!=0}
                        <tr>
                            <td align="right" ><strong>{$lang.credit}</strong> </td>
                            <td align="center"><strong>{$tax.credit|price:$currency}</strong></td>
                        </tr>
                    {/if}

                {elseif $credit}
                    {if  $credit.credit!=0}
                        <tr>
                            <td align="right" ><strong>{$lang.credit}</strong> </td>
                            <td align="center"><strong>{$credit.credit|price:$currency}</strong></td>
                        </tr>
                    {/if}
                    <tr>
                        <td align="right" >{$lang.subtotal}</td>
                        <td align="center">{$subtotal.total|price:$currency}</td>
                    </tr>
                {else}
                    <tr>
                        <td align="right" >{$lang.subtotal}</td>
                        <td align="center">{$subtotal.total|price:$currency}</td>
                    </tr>
                {/if}
                {if $subtotal.coupon}  
                    <tr >
                        <td align="right">{$lang.discount}</td>
                        <td align="center"><strong>- {$subtotal.discount|price:$currency}</strong></td>
                    </tr>  
                {/if}
                {if !empty($subtotal.recurring)}
                    <tr >
                        <td align="right">{$lang.total_recurring}</td>
                        <td align="center"> {foreach from=$subtotal.recurring item=rec key=k}	{$rec|price:$currency} {$lang.$k}<br/> {/foreach} </td>
                    </tr>
                {/if}
                <tr >

                    <td style="border:none; text-align: right; vertical-align: top" >
                        <strong>{$lang.total_today}</strong>
                        {*}<div class="left form-inline">
                            {if $subtotal.coupon}
                                <div id="promocode">{$lang.promotionalcode}: <strong>{$subtotal.coupon}</strong> 
                                    <form id="remove" method="post" action="">
                                        <input type="hidden" name="make" value="removecoupon" />
                                    </form>
                                    <a href="#" class="fs11 left" onclick="$('#remove').submit();
                                            return false;">{$lang.removecoupon}</a>
                                </div>
                            {else}
                                <div ><a href="#" onclick="$(this).hide();
                                            $('#promocode').show();
                                            return false;"><strong>{$lang.usecoupon}</strong></a></div>
                                <div id="promocode" style="display:none;">
                                    <form action="" method="post" id="promoform" >
                                        <input type="hidden" name="make" value="addcoupon" />
                                        {$lang.code}: <input type="text" class="styled" name="promocode"/> <input type="submit" value="&raquo;" style="font-weight:bold" class="padded btn"/>
                                    </form>
                                </div>
                            {/if}
                        </div>{*}
                        
                    </td>
                    <td align="center"  style="border:none">
                        <span style="vertical-align: top; font-size: 20px;">{$currency.sign}</span>
                        {if $tax}
                            <span class="cart_total">{$tax.total|price:$currency:false}</span>
                        {elseif $credit}
                            <span class="cart_total">{$credit.total|price:$currency:false}</span>
                        {else}
                            <span class="cart_total">{$subtotal.total|price:$currency:false}</span>
                        {/if}
                    </td>
                </tr>

            </tbody>
        </table>
    </div>
</div>
{if ($tax && $tax.total<0) || ($credit && $credit.total<0) || ($subtotal.total<0)}
    <div class="greenbox">{$lang.amountreturned}<b>
            {if $tax}{$tax.total|abs|price:$currency}
            {elseif $credit}{$credit.total|abs|price:$currency}
            {else}{$subtotal.total|abs|price:$currency}
            {/if}</b>
    </div>
{/if}

<form action="" method="post" onsubmit='$("#checkout").addLoader();'>
    <input type="hidden" name="make" value="upgrade" />
    <div class="wbox" {if $tax && $tax.total<=0}style="display:none"{elseif $credit && $credit.total<=0}style="display:none"{elseif $subtotal.total<=0}style="display:none"{/if}>
        <div class="wbox_header">
            <strong>{$lang.choose_payment}</strong>
        </div>
        <div class="wbox_content">
            {if $gateways}

                <center>
                    {foreach from=$gateways item=module key=mid name=payloop}
                        <input type="radio" name="gateway" value="{$mid}" {if $submit && $submit.gateway==$mid||$mid==$paygateid}checked="checked"{elseif $smarty.foreach.payloop.first}checked="checked"{/if}/> {$module}
                    {/foreach}
                </center>
            {/if}
        </div>
    </div>

    <div class="orderbox"  id="checkout">
        <div class="orderboxpadding">
            <center>
                <input type="submit" value="{$lang.submit}" style="font-size:12px;font-weight:bold"  class="padded btn"/> {$lang.or} <a href="?cmd=clientarea&action=services&service={$contents.product.account_id}">{$lang.cancel}</a>
            </center>
        </div>
    </div>
</form>