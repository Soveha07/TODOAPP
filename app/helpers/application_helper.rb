module ApplicationHelper
    def sort_link(name, column)
        direction = (params[:sort] == column && params[:direction] == "asc") ? "desc" : "asc"
        link_to "#{name} #{sort_icon(direction)}", { sort: column, direction: direction }, { class: "sort-link" }
    end
    
    def sort_icon(direction)
        direction == "asc" ? "▲" : "▼"
    end
end
