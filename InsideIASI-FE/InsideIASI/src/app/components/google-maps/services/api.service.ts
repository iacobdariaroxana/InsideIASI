import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, map } from 'rxjs';
import { AddressDTO, DistanceDTO, PointOfInterestDTO } from 'src/app/model';

@Injectable({
  providedIn: 'root',
})
export class ApiService {
  constructor(private readonly _httpClient: HttpClient) {}
  url: string = 'https://inside-iasi.azurewebsites.net/maps';
  // url: string = 'http://localhost:5217/map';
  getPointsOfInterest(
    lat: number,
    long: number,
    query: string
  ): Observable<PointOfInterestDTO[]> {
    return this._httpClient
      .get(
        `${this.url}/places?latitude=${lat}&longitude=${long}&query=${query}`
      )
      .pipe(
        map<any, PointOfInterestDTO[]>((response) => {
          return response;
        })
      );
  }

  getDistanceBetweenPlaces(
    originLat: number,
    originLong: number,
    destLat: number,
    destLong: number
  ): Observable<DistanceDTO> {
    return this._httpClient
      .get(
        `${this.url}/distance?OriginLatitude=${originLat}&OriginLongitude=${originLong}&DestLatitude=${destLat}&DestLongitude=${destLong}`
      )
      .pipe(
        map<any, DistanceDTO>((response) => {
          return response;
        })
      );
  }

  getAddressByLongitudinalCoordinates(
    lat: number,
    lng: number
  ): Observable<AddressDTO> {
    return this._httpClient
      .get(`${this.url}/address?Latitude=${lat}&Longitude=${lng}`)
      .pipe(
        map<any, AddressDTO>((response) => {
          return response;
        })
      );
  }
}

// const httpOptions = { headers: new HttpHeaders() };
// httpOptions.headers.append('Access-Control-Allow-Origin', '*');
// httpOptions.headers.append('Content-Type', 'application/json');
