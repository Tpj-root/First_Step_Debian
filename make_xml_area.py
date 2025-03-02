import random

def generate_random_color():
    """Generate a random hex color."""
    return f"#{random.randint(0, 255):02x}{random.randint(0, 255):02x}{random.randint(0, 255):02x}"

def generate_mapnik_xml():
    """Generate a Mapnik XML with random colors based on area ranges."""
    xml = '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE Map[]>
<Map background-color="#1a1a1a" srs="+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over">
  <Style filter-mode="first" name="world">
'''

    area_ranges = [
        (10000, None),  # area > 10000
        (5000, 10000),  # 5000 < area <= 10000
        (1000, 5000),   # 1000 < area <= 5000
        (500, 1000),    # 500 < area <= 1000
        (100, 500),     # 100 < area <= 500
        (0, 100)        # area <= 100
    ]

    for min_area, max_area in area_ranges:
        fill_color = generate_random_color()
        stroke_color = generate_random_color()
        
        if max_area is None:
            filter_condition = f"[area] > {min_area}"
        else:
            filter_condition = f"[area] > {min_area} && [area] <= {max_area}"

        xml += f'''    <Rule>
      <Filter><![CDATA[ {filter_condition} ]]></Filter>
      <PolygonSymbolizer fill="{fill_color}" fill-opacity="0.9" />
      <LineSymbolizer stroke="{stroke_color}" stroke-width="2" />
    </Rule>
'''

    xml += '''  </Style>
  <Layer name="world_filtered" srs="+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0.0 +k=1.0 +units=m +nadgrids=@null +wktext +no_defs +over">
    <StyleName><![CDATA[world]]></StyleName>
    <Datasource>
      <Parameter name="file"><![CDATA[very_simplified_land_polygons.gpkg]]></Parameter>
      <Parameter name="type"><![CDATA[ogr]]></Parameter>
      <Parameter name="layer"><![CDATA[very_simplified_land_polygons]]></Parameter>
      <Parameter name="srs">EPSG:3857</Parameter>
    </Datasource>
  </Layer>
</Map>'''

    return xml

# Generate and save the XML
xml_content = generate_mapnik_xml()
with open("mapnik_style.xml", "w") as f:
    f.write(xml_content)

print("Mapnik XML with area-based styling generated successfully.")
