import { Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import {
  Distance,
  DistanceDTO,
  PointOfInterest,
  PointOfInterestDTO,
} from 'src/app/model';
import { ApiService } from './api.service';
@Injectable({
  providedIn: 'root',
})
export class MapService {
  constructor(private readonly _apiService: ApiService) {}

  getPointsOfInterest(
    lat: number,
    lng: number,
    query: string
  ): Observable<PointOfInterest[]> {
    return this._apiService.getPointsOfInterest(lat, lng, query).pipe(
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
              open_now: pointOfInterest.openingHours?.open_Now,
            };
          }
        );
        return result;
      })
    );
  }

  getDistanceBetweenPlaces(
    originLat: number,
    originLong: number,
    destLat: number,
    destLong: number
  ): Observable<Distance> {
    return this._apiService
      .getDistanceBetweenPlaces(originLat, originLong, destLat, destLong)
      .pipe(
        map<DistanceDTO, Distance>((distance) => {
          return {
            number_of_km: parseFloat(distance.numberOfKilometers.text),
            eta: parseInt(distance.estimatedTime.text.split(" ")[0]),
          };
        })
      );
  }
}
