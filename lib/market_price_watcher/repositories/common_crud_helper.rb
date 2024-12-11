module MarketPriceWatcher
  module Repositories
    module CommonCrudHelper
      def list(**arguments)
        return connection.exec_params("SELECT * FROM #{table_name}") if arguments.empty?

        where_condition = arguments.map { |key, _| "#{key} = ?" }.join(" AND ")
        query = ("SELECT * FROM #{table_name} WHERE #{where_condition}")

        connection.exec_params(query, arguments.values).to_a
      end

      def find(id)
        query = "SELECT * FROM #{table_name} WHERE id = ?"

        connection.exec_params(query, [id]).to_a
      end

      def create(**attributes)
        keys = attributes.keys.join(", ")
        placeholders = attributes.keys.map.with_index { |_, i| "$#{i + 1}" }.join(", ")
        query = "INSERT INTO #{table_name} (#{keys}) VALUES (#{placeholders}) RETURNING *"

        connection.exec_params(query, attributes.values).to_a
      end

      def delete(id)
        query = "DELETE FROM #{table_name} WHERE id = $1"

        connection.exec_params(query, [id]).to_a
      end

      def update(id, **attributes)
        set_clause = attributes.keys.map.with_index { |key, i| "#{key} = $#{i + 2}" }.join(", ")

        query = "UPDATE #{table_name} SET #{set_clause} WHERE id = $1 RETURNING *"
        connection.exec_params(query, attributes.values.unshift(id)).to_a
      end
    end
  end
end