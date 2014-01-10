require 'pathname'
require Pathname.new(__FILE__).dirname.dirname.expand_path + 'pacemaker'

Puppet::Type.type(:cs_shadow).provide(:crm, :parent => Puppet::Provider::Crmsh) do
  commands :pcs => 'pcs'

  def self.instances
    block_until_ready
    []
  end

  def sync(cib)
    begin
      pcs('cluster', 'cib', 'delete', cib)
    rescue => e
      # If the CIB doesn't exist, we don't care.
    end
    pcs('cluster', 'cib', 'new', cib)
  end
end
