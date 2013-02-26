class RecipeForksGraphSp < ActiveRecord::Migration

  def self.up
     execute <<-__EOI
        CREATE PROCEDURE `ForkedRecipeIDs`( IN root INTEGER )
            NOT DETERMINISTIC
            SQL SECURITY DEFINER
            COMMENT ''
        BEGIN
          DECLARE rows SMALLINT DEFAULT 0;
          DROP TABLE IF EXISTS reached_r;
          CREATE TABLE reached_r (
            nodeID INTEGER PRIMARY KEY,
            rf_id Integer,
            revision Integer
          ) ENGINE=HEAP;
          INSERT INTO reached_r VALUES (root, 0, 0 );
          SET rows = ROW_COUNT();
          WHILE rows > 0 DO
            INSERT IGNORE INTO reached_r
              SELECT DISTINCT from_recipe_id, e.id, e.at_rev
              FROM recipe_forks AS e
              INNER JOIN reached_r AS p ON e.to_recipe_id = p.nodeID;
            SET rows = ROW_COUNT();
            INSERT IGNORE INTO reached_r
              SELECT DISTINCT to_recipe_id, e.id, e.at_rev
              FROM recipe_forks AS e
              INNER JOIN reached_r AS p ON e.from_recipe_id = p.nodeID;
            SET rows = rows + ROW_COUNT();
          END WHILE;
          SELECT * FROM reached_r;
          DROP TABLE reached_r;
        END;
     __EOI
  end

   def self.down
     execute "DROP PROCEDURE IF EXISTS `ForkedRecipeIDs`"
   end


end
