renderValues = (buffer, object) ->
  for key, value of object when typeof value == 'string'
    renderNode buffer, value if buffer.hasClass key or buffer.is key

    for node in buffer.find("#{key}, .#{key}")
      renderNode jQuery(node), value

renderDirectives = (buffer, object, directives) ->
  for key, directive of directives when typeof directive == 'function'
    [key, attribute] = key.split('@')

    if buffer.hasClass key or buffer.is key
      renderNode buffer, directive.call(object, buffer), attribute

    for node in buffer.find("#{key}, .#{key}")
      node = jQuery(node)
      renderNode node, directive.call(object, node), attribute

renderChildren = (buffer, object, directives) ->
  for key, value of object when typeof value == 'object' and key != 'parent_'
    value.parent_ = object
    buffer.render value, directives[key] if buffer.hasClass key
    buffer.find(".#{key}").render value, directives[key]

renderNode = (node, value, attribute) ->
  if attribute
    node.attr attribute, value
  else
    children = node.children().detach()
    node.text value
    node.append children

jQuery.fn.render = (data, directives) ->
  directives ||= {}
  result       = this
  contexts     = if jQuery.isArray(data) then @children() else [this]

  for context in contexts
    context   = jQuery(context)
    template  = context.clone()
    data      = [data] unless jQuery.isArray(data)

    for object in data
      buffer = template.clone()

      renderValues     buffer, object
      renderDirectives buffer, object, directives
      renderChildren   buffer, object, directives
      context.before(buffer)

    context.remove() # Remove the original template from the dom

  return result
