node :actions do
  {
    :first => @resource.url_for(:first_page),
    :last => @resource.url_for(:last_page)
  }.tap do |actions|
    actions[:next] = @resource.url_for(:next_page) if @resource.next_page
    actions[:previous] = @resource.url_for(:previous_page) if @resource.previous_page
  end
end

node :size do
  @objects.size
end

child @objects => @resource.name do
  attributes *@resource.attributes
end
