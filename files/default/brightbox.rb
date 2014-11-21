#
# Author:: Tim Dysinger (<tim@dysinger.net>)
# Author:: Benjamin Black (<bb@opscode.com>)
# Author:: Christopher Brown (<cb@opscode.com>)
# Author:: John Daniels (<john@semantici.st>)
# Copyright:: Copyright (c) 2009 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'ohai/mixin/ec2_metadata'

Ohai.plugin(:Brightbox) do
  include Ohai::Mixin::Ec2Metadata

  provides "brightbox"

  depends "network/interfaces"

  def get_mac_address(addresses)
    detected_addresses = addresses.detect { |address, keypair| keypair == {"family"=>"lladdr"} }
    if detected_addresses
      return detected_addresses.first
    else
      return ""
    end
  end

  def has_brightbox_mac?
    network[:interfaces].values.each do |iface|
      has_mac = (get_mac_address(iface[:addresses]) =~ /^02:24:/)
      Ohai::Log.debug("has_brightbox_mac? == #{!!has_mac}")
      return true if has_mac
    end

    Ohai::Log.debug("has_brightbox_mac? == false")
    false
  end

  def looks_like_brightbox?
    # Try non-blocking connect so we don't "block" if
    # the Xen environment is *not* EC2
    hint?('brightbox') || has_brightbox_mac? && can_metadata_connect?(Ohai::Mixin::Ec2Metadata::EC2_METADATA_ADDR,80)
  end

  collect_data do
    if looks_like_brightbox?
      Ohai::Log.debug("looks_like_brightbox? == true")
      brightbox Mash.new
      self.fetch_metadata.each do |k, v|
        brightbox[k] = v
      end
      brightbox[:userdata] = self.fetch_userdata
    else
      Ohai::Log.debug("looks_like_brightbox? == false")
      false
    end
  end
end
