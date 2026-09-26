import sys, json
from functools import cmp_to_key


def cmp(a, b):
    return (a > b) - (a < b)


def cmp_field(a, b, field, reverse=False):
    x, y = a.get(field), b.get(field)

    if x is None:
        return 0 if y is None else 1
    if y is None:
        return -1

    return cmp(y, x) if reverse else cmp(x, y)


def compare(a, b):
    c = cmp_field(a, b, "provider")
    if c:
        return c

    c = cmp_field(a, b, "last_updated", reverse=True)
    if c:
        return c

    c = cmp_field(a, b, "knowledge", reverse=True)
    if c:
        return c

    return cmp_field(a, b, "id")


xs = [json.loads(line) for line in sys.stdin]
xs.sort(key=cmp_to_key(compare))

for x in xs:
    print(json.dumps(x, separators=(",", ":")))
