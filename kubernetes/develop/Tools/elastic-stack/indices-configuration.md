# Index patterns

apm-staging*
elastic-stack-staging*
heartbeat-7-staging*
ingress-nginx-staging*
kube-system-staging*
application-staging*

# Index Lifecycle
```
PUT _ilm/policy/apm-homolog
{
  "policy": {
    "_meta": {
      "description": "used for apm logs",
      "project": {
        "name": "tidas",
        "department": "ti"
      }
    },
    "phases": {
      "delete": {
        "min_age": "7d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```
```
PUT _ilm/policy/elastic-stack-homolog
{
  "policy": {
    "_meta": {
      "description": "used for elastic-stack kubernetes logs",
      "project": {
        "name": "tidas",
        "department": "ti"
      }
    },
    "phases": {
      "delete": {
        "min_age": "2d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```
```
PUT _ilm/policy/heartbeat-7-homolog
{
  "policy": {
    "_meta": {
      "description": "used for heartbeat logs",
      "project": {
        "name": "tidas",
        "department": "ti"
      }
    },
    "phases": {
      "delete": {
        "min_age": "3d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```
```
PUT _ilm/policy/ingress-nginx-homolog
{
  "policy": {
    "_meta": {
      "description": "used for ingress-nginx kubernetes logs",
      "project": {
        "name": "tidas",
        "department": "ti"
      }
    },
    "phases": {
      "delete": {
        "min_age": "3d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```
```
PUT _ilm/policy/kube-system-homolog
{
  "policy": {
    "_meta": {
      "description": "used for kube-system kubernetes logs",
      "project": {
        "name": "tidas",
        "department": "ti"
      }
    },
    "phases": {
      "delete": {
        "min_age": "3d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```

```
PUT _ilm/policy/application-homolog
{
  "policy": {
    "_meta": {
      "description": "used for customer application kubernetes logs",
      "project": {
        "name": "tidas",
        "department": "ti"
      }
    },
    "phases": {
      "delete": {
        "min_age": "7d",
        "actions": {
          "delete": {}
        }
      }
    }
  }
}
```

# Index templates

Apply by Console DevTools

```
PUT _index_template/apm-homolog
{
  "index_patterns": ["apm-homolog*"],
  "template": { 
    "settings": {
      "number_of_shards": 1,
      "index.lifecycle.name": "apm-homolog"
    },
    "mappings": {
      "_source": {
        "enabled": true
      }
    }
  }
}

PUT apm-homolog*/_settings 
{
  "index": {
    "lifecycle": {
      "name": "apm-homolog"
    }
  }
}
```
```
PUT _index_template/elastic-stack-homolog
{
  "index_patterns": ["elastic-stack-homolog*"],
  "template": {
    "settings": {
      "number_of_shards": 1,
      "index.lifecycle.name": "elastic-stack-homolog"
    },
    "mappings": {
      "_source": {
        "enabled": true
      }
    }
  }
}
PUT elastic-stack-homolog*/_settings 
{
  "index": {
    "lifecycle": {
      "name": "elastic-stack-homolog"
    }
  }
}
```
# heartbeat always create our index template
PUT heartbeat-7-homolog*/_settings 
{
  "index": {
    "lifecycle": {
      "name": "heartbeat-7-homolog"
    }
  }
}
```
```
PUT _index_template/ingress-nginx-homolog
{
  "index_patterns": ["ingress-nginx-homolog*"],
  "template": {
    "settings": {
      "number_of_shards": 1,
      "index.lifecycle.name": "ingress-nginx-homolog"
    },
    "mappings": {
      "_source": {
        "enabled": true
      }
    }
  }
}
PUT ingress-nginx-homolog*/_settings 
{
  "index": {
    "lifecycle": {
      "name": "ingress-nginx-homolog"
    }
  }
}
```
```
PUT _index_template/kube-system-homolog
{
  "index_patterns": ["kube-system-homolog*"],
  "template": {
    "settings": {
      "number_of_shards": 1,
      "index.lifecycle.name": "kube-system-homolog"
    },
    "mappings": {
      "_source": {
        "enabled": true
      }
    }
  }
}
PUT kube-system-homolog*/_settings 
{
  "index": {
    "lifecycle": {
      "name": "kube-system-homolog"
    }
  }
}
```
PUT _index_template/application-homolog
{
  "index_patterns": ["application-homolog*"],
  "template": {
    "settings": {
      "number_of_shards": 1,
      "index.lifecycle.name": "application-homolog"
    },
    "mappings": {
      "_source": {
        "enabled": true
      }
    }
  }
}
PUT application-homolog*/_settings 
{
  "index": {
    "lifecycle": {
      "name": "application-homolog"
    }
  }
}
```