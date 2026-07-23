//
// utils/core.pwn
//

stock Uptime()
{
    new horas, minutos, segundos, total = GetTickCount() / 1000;
    horas = total / 3600;
    minutos = (total % 3600) / 60;
    segundos = total % 60;
    new str[32];
    format(str, sizeof(str), "%02d:%02d:%02d", horas, minutos, segundos);
    return str;
}
