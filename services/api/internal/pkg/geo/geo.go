// Package geo implements the provider-agnostic delivery-zone checks
// described in docs/ARCHITECTURE.md: plain lat/lng plus a GeoJSON polygon
// stored in Postgres, no map SDK / PostGIS dependency required.
package geo

import "math"

// Point is a WGS84 coordinate.
type Point struct {
	Lat float64
	Lng float64
}

// Polygon is a parsed GeoJSON "Polygon" geometry: a list of linear rings,
// each a closed list of [lng, lat] pairs. Ring 0 is the exterior ring;
// subsequent rings (if any) are holes.
type Polygon [][][2]float64

// Contains reports whether p lies inside the polygon using the standard
// ray-casting algorithm on the exterior ring, with holes subtracted.
func (poly Polygon) Contains(p Point) bool {
	if len(poly) == 0 {
		return false
	}
	if !ringContains(poly[0], p) {
		return false
	}
	for _, hole := range poly[1:] {
		if ringContains(hole, p) {
			return false
		}
	}
	return true
}

// ringContains implements ray casting for a single linear ring. Coordinates
// are GeoJSON order: [lng, lat].
func ringContains(ring [][2]float64, p Point) bool {
	inside := false
	n := len(ring)
	if n < 3 {
		return false
	}
	for i, j := 0, n-1; i < n; j, i = i, i+1 {
		xi, yi := ring[i][0], ring[i][1]
		xj, yj := ring[j][0], ring[j][1]
		intersects := ((yi > p.Lat) != (yj > p.Lat)) &&
			(p.Lng < (xj-xi)*(p.Lat-yi)/(yj-yi)+xi)
		if intersects {
			inside = !inside
		}
	}
	return inside
}

// HaversineKM returns the great-circle distance in kilometers between two
// points, used to sort/filter "nearby stores".
func HaversineKM(a, b Point) float64 {
	const earthRadiusKM = 6371.0
	lat1 := a.Lat * math.Pi / 180
	lat2 := b.Lat * math.Pi / 180
	dLat := (b.Lat - a.Lat) * math.Pi / 180
	dLng := (b.Lng - a.Lng) * math.Pi / 180
	h := math.Sin(dLat/2)*math.Sin(dLat/2) +
		math.Cos(lat1)*math.Cos(lat2)*math.Sin(dLng/2)*math.Sin(dLng/2)
	c := 2 * math.Atan2(math.Sqrt(h), math.Sqrt(1-h))
	return earthRadiusKM * c
}

// ParseGeoJSONPolygon converts a decoded GeoJSON "coordinates" array
// (interface{} from encoding/json) into a Polygon. Malformed input yields an
// empty Polygon rather than an error, since a delivery zone with unreadable
// geometry should simply never match.
func ParseGeoJSONPolygon(coordinates any) Polygon {
	rawRings, ok := coordinates.([]any)
	if !ok {
		return nil
	}
	var poly Polygon
	for _, rr := range rawRings {
		rawPoints, ok := rr.([]any)
		if !ok {
			continue
		}
		var ring [][2]float64
		for _, rp := range rawPoints {
			pair, ok := rp.([]any)
			if !ok || len(pair) < 2 {
				continue
			}
			lng, ok1 := toFloat(pair[0])
			lat, ok2 := toFloat(pair[1])
			if !ok1 || !ok2 {
				continue
			}
			ring = append(ring, [2]float64{lng, lat})
		}
		if len(ring) >= 3 {
			poly = append(poly, ring)
		}
	}
	return poly
}

func toFloat(v any) (float64, bool) {
	f, ok := v.(float64)
	return f, ok
}
