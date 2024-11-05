import { LightningElement, track } from 'lwc';
import getWeatherByCity from '@salesforce/apex/WeatherService.getWeatherByCity';

export default class WeatherLwc extends LightningElement {

    @track cityName = '';
    @track weatherData;

    handleCityChange(event) {
        this.cityName = event.target.value;
    }

    async fetchWeather() {
        try {
            this.weatherData = await getWeatherByCity({ cityName: this.cityName });
        } catch (error) {
            console.error('Error fetching weather:', error);
        }
    }
}