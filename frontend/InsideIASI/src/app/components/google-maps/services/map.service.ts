import { Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { PointOfInterest, PointOfInterestDTO } from 'src/app/model';
import { ApiService } from './api.service';
@Injectable({
  providedIn: 'root',
})
export class MapService {
  constructor(private readonly _apiService: ApiService) {}

  getPointsOfInterest(lat: number, lng: number, query: string): Observable<PointOfInterest[]> {
    return this._apiService
      .getPointsOfInterest(lat, lng, query)
      .pipe(
        map<PointOfInterestDTO[], PointOfInterest[]>((pointsOfInterest) => {
          const result: PointOfInterest[] = pointsOfInterest.map(
            (pointOfInterest) => {
              return {
                position: {
                  lat: pointOfInterest.geometry.location.lat,
                  lng: pointOfInterest.geometry.location.lng,
                },
                name: pointOfInterest.name,
                icon: pointOfInterest.icon,
                rating: pointOfInterest.rating,
                open_now: pointOfInterest.opening_Hours?.openNow
              };
            }
          );
          return result;
        })
      );
  }


}
