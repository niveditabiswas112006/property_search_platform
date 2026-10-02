import json
import re
import os

transcript_path = '/Users/niveditabiswas/.gemini/antigravity-ide/brain/153b5654-ad2d-4e88-b7b1-4ca15116be79/.system_generated/logs/transcript_full.jsonl'

cities = []
with open(transcript_path, 'r') as f:
    for line in f:
        try:
            data = json.loads(line)
            if data.get('type') == 'USER_INPUT' and 'All cities' in data.get('content', ''):
                content = data['content']
                matches = re.findall(r'\[([^\]]+)\]\(([^\)]+)\)', content)
                if matches:
                    cities = matches
        except:
            pass

if not cities:
    print("No cities found")
else:
    dart_content = "class CityData {\n"
    dart_content += "  static const List<Map<String, String>> cities = [\n"
    for name, url in cities:
        name = name.replace("'", "\\'")
        url = url.replace("'", "\\'")
        dart_content += f"    {{'name': '{name}', 'url': '{url}'}},\n"
    dart_content += "  ];\n"
    dart_content += "}\n"
    
    os.makedirs('/Users/niveditabiswas/property_search_platform/lib/constants', exist_ok=True)
    with open('/Users/niveditabiswas/property_search_platform/lib/constants/cities.dart', 'w') as f:
        f.write(dart_content)
    print(f"Successfully wrote {len(cities)} cities to lib/constants/cities.dart")
