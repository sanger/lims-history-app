node :actions do
  {
    :first => url_for(:first_page),
    :last => url_for(:last_page)
  }.tap do |actions|
    actions[:next] = url_for(:next_page) if next_page?
    actions[:previous] = url_for(:previous_page) if previous_page?
  end
end

node :size do
  @objects.size
end

child @objects => @resource_page.name do
  node(:actions) do |object|
    {:read => url_for(object.uuid)}
  end

  attributes *@resource_page.attributes
end

