
{if !$mode}
    {literal}
        <script type="text/javascript">
            $(function() {
                $('.form_container').hide().eq(0).show();
                $('.content .fleft > div').eq(0).addClass('actv');
                $('.content .fleft > div').each(function(x) {
                    $(this).click(function() {
                        actv_form = x;
                        $('.form_container').hide().eq(x).show();
                        $('.content .fleft > div').removeClass('actv').eq(x).addClass('actv');
                    });
                });
                $("a.vtip_description").vTip();
                inichosen();
            });

            function showDevice(id) {
                $.facebox({
                    ajax: "?cmd=module&module={/literal}{$dedimgr}{literal}&do=itemeditor&item_id=" + id,
                    width: 900,
                    nofooter: true,
                    opacity: 0.8,
                    addclass: 'modernfacebox'
                });
                return false;
            }

            function ipam_ipsubmit(form) {
                ajax_update("?cmd=module&module=ipam", form.serializeObject(), function(data) {
                    if (typeof refreshTree == 'function') {
                        refreshTree();
                        refreshView();
                    }else if(typeof loadIpamMGR == 'function'){
                        loadIpamMGR();
                    }
                    $(document).trigger('close.facebox');
                });
            }

            function inichosen() {
                if (typeof jQuery.fn.chosen != 'function') {
                    $('<style type="text/css">@import url("templates/default/js/chosen/chosen.css")</style>').appendTo("head");
                    $.getScript('templates/default/js/chosen/chosen.min.js', function() {
                        inichosen();
                        return false;
                    });
                    return false;
                }

                $('#client_id', '#facebox').each(function(n) {
                    var that = $(this);
                    var selected = that.attr('default');
                    $.get('?cmd=clients&action=json', function(data) {
                        if (data.list != undefined) {
                            for (var i = 0; i < data.list.length; i++) {
                                var name = data.list[i][3].length ? data.list[i][3] : data.list[i][1] + ' ' + data.list[i][2];
                                var select = selected == data.list[i][0] ? 'selected="selected"' : '';
                                that.append('<option value="' + data.list[i][0] + '" ' + select + '>#' + data.list[i][0] + ' ' + name + '</option>');
                            }
                        }
                        reloadServices();
                        that.chosen();
                    });
                });
            }

            function reloadServices() {
                ajax_update('?cmd=module&module=ipam&action=getclientservices', {client_id: $("#client_id").val(), service_id: $('#account_id').val()}, '#related_service');
            }
        </script>
    {/literal}
    <table width="100%"><tr>
            <td class="fleft">
                <div>General details</div>
                <div>Assignment</div>
                <div>Hardware</div>
                <div>Audit Log</div>
            </td>
            <td class="fright">
                <h3 style="margin-bottom:0px;">
                    Edit IP Details and assigment
                </h3>
                <form action="?cmd=module&module={$moduleid}" method="post" onsubmit="return false" id="edit_ipform">
                    <input type="hidden" name="action" value="editip" />
                    <input type="hidden" name="save" value="{$item.server_id}" />
                    <input type="hidden" name="id" value="{$item.id}" />
                    <br/>
                    <div class="form_container">

                        <label>IP</label><input type="text" name="ipaddress" value="{$item.ipaddress}" />
                        <div class="clear"></div>

                        <label>Netmask</label><input type="text" name="mask" value="{$item.mask}" />
                        <div class="clear"></div>

                        <label>Hostname</label><input type="text" name="domains" value="{$item.domains}" />
                        <div class="clear"></div>

                        <label>RDNS</label><textarea class="w250" name="revdns">{$item.revdns}</textarea>
                        <div class="clear"></div>

                        <label>Admin description</label><textarea class="w250" name="descripton">{$item.descripton}</textarea>
                        <div class="clear"></div>

                        <label>Client description</label><textarea class="w250" name="client_description">{$item.client_description}</textarea>
                        <div class="clear"></div>

                        <label>Status</label><input type="text" value="{$item.status}" readonly="readonly"/>
                        <div class="clear"></div>

                    </div>
                    <div class="form_container">

                        <label class="nodescr">Owner</label>
                        <select  class="w250" name="client_id" load="clients" default="{$item.client_id}" id="client_id" onchange="reloadServices()"><option value="0">None</option></select>
                        <div class="clear"></div>

                        <div id="related_service">
                            <label class="nodescr">Related service</label>
                            <input type="text"   size="" value="{$item.account_id}" class="w250" name="account_id" id="account_id" />
                            <div class="clear"></div>
                        </div>

                        {if $dedimgr}
                            <div id="related_service">
                                <label class="nodescr">Related device/port</label>
                                <div style="margin: 7px 0 20px 10px;" class="left">
                                    {if $item.port}
                                        <a href="?cmd=module&module=dedimgr&do=rack&rack_id={$item.port.rack_id}&expand={$item.port.id}" target="_blank">
                                            {$item.port.typename} - {$item.port.label} ({$item.port.number})
                                        </a>
                                    {else}
                                        <em>No device/port assigned in <a href="?cmd=module&module=dedimgr" target="_blank">Dedimgr</a></em> 
                                    {/if}
                                </div>
                                <div class="clear"></div>
                            </div>
                        {/if}
                    </div>
                    <div class="form_container">
                        {if $dedimgr}
                            {if !$port1 && !$port2}
                                <p><em>No device/port assigned in <a href="?cmd=module&module=dedimgr" target="_blank">Dedimgr</a></em> </p>
                            {else}
                                <p><strong>Related devices and ports</strong></p>
                                <div class="clear"></div>
                                <a href="?cmd=module&module=dedimgr&do=rack&rack_id={$port1.rack_id}&expand={$port1.item_id}" target="_blank" style="display: block; padding: 7px; float: left;">
                                    {$port1.label} -
                                    #{$port1.number} 
                                {if $port1.port_name} ({$port1.port_name}){/if}
                            {if $port1.mac} MAC:{$port1.mac|upper}{/if}
                        </a>

                        {if $port2}
                            <div class="join_type"><div><img src="templates/default//img/arrow.png"></div></div>
                            <div class="clear"></div>

                            <a href="?cmd=module&module=dedimgr&do=rack&rack_id={$port2.rack_id}&expand={$port2.item_id}" target="_blank" style="display: block; padding: 7px; float: left;">
                                {$port2.label} -
                                #{$port2.number} 
                            {if $port2.port_name} ({$port2.port_name}){/if}
                        {if $port2.mac} MAC:{$port2.mac|upper}{/if}
                    </a>
                {/if}
            {/if}
        {else}
            <p><em>This option is available only when Dedicated Servers Manager is present</em></p>
        {/if}
    </div>
    <div class="form_container">
        <table style="width: 100%" cellspacing="0" cellpadding="6">
            <tr>
                <th>Date</th>
                <th>Change</th>
                <th>By</th>
            </tr>
            {foreach from=$logs item=log}
                <tr>
                    <td>{$log.date}</td>
                    <td>{$log.log}</td>
                    <td>{$log.changedby}</td>
                </tr>
            {foreachelse}
                <tr><td colspan="3">No logs available</td></tr>
                {/foreach}
        </table>
    </div>
</form>
</td>
</tr>
</table>
<div style=" background: #272727; box-shadow: 0 -1px 2px rgba(0, 0, 0, 0.3); color: #FFFFFF; height: 20px; padding: 11px 11px 10px; clear:both">
    <div class="left spinner" style="display: none;">
        <img src="ajax-loading2.gif">
    </div>
    <div class="right">
        <span class="bcontainer ">
            <a class="new_control greenbtn" onclick="ipam_ipsubmit($('#edit_ipform', '#facebox'));
                return false" href="#">
                <span>Save</span>
            </a>
        </span>
        <span class="bcontainer">
            <a class="submiter menuitm" href="#" onclick="$(document).trigger('close.facebox');
                return false;">
                <span>Close</span>
            </a>
        </span>
    </div>
    <div class="clear"></div>
</div>
{elseif $mode == 'testcon'}
{if $conection == 1}<span class="Successfull"><strong>Successfull!</strong></span>{else}<span class="error">Error: {$conection}</span>{/if}
{/if}